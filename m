From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: Problem of NAT with VLAN
Date: Wed, 09 Apr 2003 18:19:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E94481C.4040701@fl.priv.at>
References: <8C19E3FBB6467846AFF97E366D34CB600189A4A3@lanmhs20.rd.francetelecom.fr>
Reply-To: netfilter-devel@lists.netfilter.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <8C19E3FBB6467846AFF97E366D34CB600189A4A3@lanmhs20.rd.francetelecom.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

zze-Proxy_Corveller ball001 exterieur FTRD wrote:
> 
> I've got n VLANs that arrive on a Linux machine. I'm using vconfig to
> receive packets from those VLANs.
> 
> I want to perform DNAT on packets between my physical interface (eth2) 
> and the virtuals devices
> created by vconfig (vlan00xx, where xx is the VLAN ID of the associated 
> VLAN).
> I've place some rules at the PREROUTING chain in the nat table to 
> perform the address
> translation.
> 
> My problem is that netfilter seems don't see packets between eth2 and 
> vlan00xx.
> 
> I've tried some rules such as '-A PREROUTING -i eth2' or '-A PREROUTING 
> -i vlan0010' but
> the packet counters stay equal to 0.
> 
> Any idea ?
> 

Just curious, did you run:
   vconfig set_name_type VLAN_PLUS_VID
   vconfig add eth2 10

-- 
MfG / Regards
Friedrich Lobenstock
