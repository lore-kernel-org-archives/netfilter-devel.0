From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Match & target structure history in 2.4.28 and 2.6.x series
Date: Fri, 12 Jan 2007 12:49:59 +0200
Message-ID: <45A767D7.2000800@outerspace.dyndns.org>
References: <45A6832F.2070703@outerspace.dyndns.org>
	<Pine.LNX.4.61.0701121122140.17236@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701121145090.17236@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701121145090.17236@yvahk01.tjqt.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
>>> In the hope that it will help people write matches & targets that are 
>>> compatible with not only the newest version of linux, I wrote a page 
>>> showing the changes to the match & target structs used in kernel code 
>>> in the 2.6 series since 2.4.28:
>> You could add 2.6.20-rc4 (to become 2.6.20).
> 
> Oh right. Well, I just thought of this peculiarity in 2.6.20:
> 
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
> #    define nfmark mark
> #endif
> 
> void foobar(struct sk_buff *skb) {
>     printk("Mark is %d\n", skb->nfmark);
> }

Oh right.. well I haven't covered structures other than the *_match and
*_target ones.. I'm sure there's a lot else out there that could/should
be documented in the same way.. :) Maybe I could create a separate page
for sk_buff..?
