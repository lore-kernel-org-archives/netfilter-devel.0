From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connttrack problem - 'unexpecting' performed too early?
Date: Tue, 13 Apr 2004 11:21:22 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407B4092.3060604@snapgear.com>
References: <BAY13-F92qgIjOiwsN300050707@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Colin Paton <cozzarp@hotmail.com>
In-Reply-To: <BAY13-F92qgIjOiwsN300050707@hotmail.com>
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
> Can anyone advise? I'm not 100% sure of the nature of the 'expect' stuff, 
> which is perhaps where my misunderstanding is coming from. I'm wondering if 
> the other end should be 'unexpected' only AFTER GRE reply has been seen, but 
> am not quite sure.

For most protocols, the first packet in the connection will be in a
predetermined direction, so expectations are set up to only expect a
packet in that direction.  But the first packet in a GRE connection
can be sent by either end, so two expectations must be created.

However, once an expectation is matched, a conntrack entry is created
that will match packets in either direction.  So once the first GRE
expectation is matched, the expectation for the other direction can
be deleted immediately.  There is no need to wait for the reply.

An additional complication with GRE is that it uses a different ID
in either direction, so in order to match up the packets in either
direction, a 'keymap' is used.  The pptp helper creates 2 keymaps
for each expectation, for a total of 4 keymaps.  When an expectation
is matched, its 2 keymaps are used for the conntrack entry.  But
the other 2 keymaps are deleted by ip_ct_gre_keymap_destroy when
the other expectation is deleted.

What your change is accomplishing is to keep one of the keymaps for
the other expectation (for ever).  This shouldn't be needed, so if
it fixes things, it is probably because the keymap for the matched
expectation is wrong.

> I enclose a debug log.

Your log doesn't have any debug info from ip_nat_pptp.c or
ip_nat_proto_gre.c.  Have you insmod'ed them?  If you haven't then
that would explain why the keymap is wrong.  If you have, then please
enable debug for them also, and resend the log.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com
