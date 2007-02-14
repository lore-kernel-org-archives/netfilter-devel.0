From: Alexander Sirotkin <demiurg@metalinkBB.com>
Subject: Re: netfilter performance on low-end embedded systems
Date: Wed, 14 Feb 2007 11:31:11 +0200
Message-ID: <45D2D6DF.4030200@metalinkbb.com>
References: <7e63f56c0702120822v4d4d27cble4d9c07afc40741d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Robert Iakobashvili <coroberti@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <7e63f56c0702120822v4d4d27cble4d9c07afc40741d@mail.gmail.com>
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


Robert Iakobashvili wrote:
> Alexander,
>
>
>> From: Alexander Sirotkin <demiurg@metalinkBB.com>
>
>> I'm trying to evaluate the feasibility of using netfilter on low-end
>> embedded processors, such as MIPS 4K or 24K. Basicly what I'm trying to
>> understand is whether we can do 100Bps with netfilter enabled (firewall
>> and NAT) on such a CPU or should we check hardware acceleration 
>> solution.
>>
>> If anybody did any similar benchmarks and can share results (does not
>> have to be on MIPS) or just has any opinion on the subject - I'd be very
>> grateful.
>
> With reference to the low-end arm processors, high traffic is not a
> problem, unless
> you are not using a large number of iptables rules, which traversal by 
> packets
> is linear.
Well, this is not entirely correct.
I started doing some benchmarks myself on MIPS 24K 266MHz which is 
fairly common embedded CPU and the results are not very good. Under 
100Mbps UDP traffic just compiling netfilter increases CPU utilization 
by 20%.

Profiling shows that most time is spent in nf_hook_slow (8%) and 
nf_iterate (7%) functions. I can post more results in case anybody is 
interested to discuss this.
> If you need lots many rules, e.g. hundreds, thousands, etc, consider
> using various
> flavors of ipset, nf-hypac, connection tracking, wise rules 
> arrangement, etc.
>
>
> Sincerely,
> Robert Iakobashvili,
> coroberti %x40 gmail %x2e com
> ...................................................................
> Navigare necesse est, vivere non est necesse
> ...................................................................
> http://sourceforge.net/projects/curl-loader
> A powerful open-source HTTP/S, FTP/S traffic
> generating, loading and testing tool.


-- 
Alexander Sirotkin

System Engineer
System Architecture Group

Metalink Broadband Ltd.

Phone:   +972-9-9605360
Fax:     +972-9-9605344
Mobile: +972-54-4959034


-- Disclaimer: --
This e-mail is intended solely for the person to whom it is addressed and may contain confidential or legally privileged information. Access to this e-mail by anyone else is unauthorized. If an addressing or transmission error has misdirected this e-mail, please notify the author by replying to this e-mail and destroy this e-mail and any attachments.
E-mail may be susceptible to data corruption, interception, unauthorized amendment, viruses and delays or the consequences thereof. If you are not the intended recipient, be advised that you have received this email in error and that any use, dissemination, forwarding, printing or copying of this email is strictly prohibited.
