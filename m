From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Thu, 10 Apr 2003 15:28:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E957173.6090103@fl.priv.at>
References: <Pine.GSO.4.03.10304092023000.11290-100000@shemp.vdata.com>
Reply-To: netfilter-devel@lists.netfilter.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.GSO.4.03.10304092023000.11290-100000@shemp.vdata.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

Jeff Hall wrote:
> I found the following discussion on the www.sonicwall.com/support site.
> It may explain the mystery of the broken/not-broken check sums.
> 
> Jeff Hall
> 
> SonicWALL: In certain circumstances, a Windows 2000 PC cannot use PPTP to
> access another node on the opposite side of the SonicWall. The issue
> appears to be caused by how certain checksums are calculated differently
> depending on whether this function is performed by the OS itself or if it
> is off-loaded to the ethernet NIC. 
> To work around the issue, you must make sure the OS is allowed to perform
> the checksum calculations, not the ethernet NIC. This can be done by
> following these steps: 
> Right-click the 'My Network Places' desktop icon and select 'Properties'. 
> Right-click on the icon for your ethernet NIC and select 'Properties'. 
> Click on the 'Configure' button. 
> Click on the 'Advanced' tab. 
> Disable the Rx and Tx Checksum Offload options for the card.
> This problem is known to occur with the following: 
> OS: Windows 2000 with service pack 1 
> Ethernet NIC: 3Com 905/920 series ethernet controller. 

May I recall that I really have to remove the // to get it running.

/* track caller id inside control connection, call expect_related */
static int
conntrack_pptp_help(const struct iphdr *iph, size_t len,
                     struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)

{ ...

         /* checksum invalid? */
         if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
                         csum_partial((char *) tcph, tcplen, 0))) {
                 printk(KERN_NOTICE __FILE__ ": bad csum\n");
//             return NF_ACCEPT;
         }

If I take a look at the cvs version of the patch there's a comment
above the // line that says that w2k servers send out false csums.

So do I understand this correct that if I remove the //, the pptp
contrack module actually is more RFC conform than before? Or is
it just the other way round?

-- 
MfG / Regards
Friedrich Lobenstock
