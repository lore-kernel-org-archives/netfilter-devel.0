From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Fri, 11 Apr 2003 12:48:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E969D88.4070005@fl.priv.at>
References: <Pine.GSO.4.03.10304101552590.4253-100000@shemp.vdata.com>
Reply-To: netfilter-devel@lists.netfilter.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.GSO.4.03.10304101552590.4253-100000@shemp.vdata.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jeff Hall wrote:
> On Thu, 10 Apr 2003, Friedrich Lobenstock wrote:
>> May I recall that I really have to remove the // to get it running.
>> 
>> /* track caller id inside control connection, call expect_related */
>> static int
>> conntrack_pptp_help(const struct iphdr *iph, size_t len,
>>                      struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
>> 
>> { ...
>> 
>>          /* checksum invalid? */
>>          if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
>>                          csum_partial((char *) tcph, tcplen, 0))) {
>>                  printk(KERN_NOTICE __FILE__ ": bad csum\n");
>> //             return NF_ACCEPT;
>>          }
>> 
>> If I take a look at the cvs version of the patch there's a comment
>> above the // line that says that w2k servers send out false csums.
>> 
>> So do I understand this correct that if I remove the //, the pptp
>> contrack module actually is more RFC conform than before? Or is
>> it just the other way round? 
>
> If you remove the comment and include the line "return NF_ACCEPT", then any
> packet with an invalid checksum is NOT processed by the PPTP helper function.
> With the line commented out the incorrect checksum is ignored and the packet
> is processed by the rest of the PPTP helper function. Why this solved your
> problem I can't say.

I don't know either. Because of this I ask the author of this module to
make this an option to the module, so I do not have to create two different
versions of devil linux to support both possibilities.

-- 
MfG / Regards
Friedrich Lobenstock
