From: Philip Craig <philipc@snapgear.com>
Subject: Re: Netfilter/PPTP/GRE weirdness - only when used with 'tap' device
Date: Wed, 16 Jun 2004 17:44:39 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CFFA67.8040808@snapgear.com>
References: <BAY22-F4x5ElptLnpp000050866@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Colin Paton <cozzarp@hotmail.com>
In-Reply-To: <BAY22-F4x5ElptLnpp000050866@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Colin Paton wrote:
> It would appear that ip_nat_proto_gre.c function gre_manip_pkt() is only 
> being called for the first packet (client->PPTP server) and is not being 
> called for the response (PPTP server->laptop) - or at least a DEBUGP there 
> only occurs once.
> 
> I *think* (but this is where I begin to get out of my depth a bit) that the 
> correct keymap entries aren't being added to the tables in 
> ip_conntrack_proto_gre, and hence the gre_manip_pkt() isn't being called for 
> the return entry. I'm not sure why though.

For the working case, your logs show ip_ct_gre_keymap_destroy being
called only once.  But for the broken case, it is called twice.  Since
there are only two sets of keymaps, this means that all the keymap
entries are deleted and so subsequent packets can't match any.

Can you give full logs?  Or at least show what is going on in
ip_conntrack_pptp also.

pptp conntrack uses two expectations, but when the first one is matched
it deletes the other one.  My initial suspicion is that the packet is
going through conntrack twice, and we are trying to delete the other
expectation twice, but since it is already deleted the second time, we
end up deleting both expectations.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com
