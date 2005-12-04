From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [PATCH 2.4] TCP window tracking: nf-log
Date: Sun, 04 Dec 2005 19:07:08 +0100
Message-ID: <4393304C.2030100@drugphish.ch>
References: <43819E46.4020603@tac.ch> <20051204135139.GA5570@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20051204135139.GA5570@alpha.home.local>
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

Hi Willy,

Thanks for your review.

> On Mon, Nov 21, 2005 at 11:15:34AM +0100, Roberto Nibali wrote:
>> Hello,
>>
>> This is the rediffed nf-log patch against 2.4.32, which is needed in
>> order to have the core tcp window tracking patch working in 2.4.x kernels.
> 
> I've fixed two things which prevented it from compiling :
>   - removed a space change in ip_vs_conn.c which might have been caused
>     by a change in your reference 2.4.32 tree ;

Hmm, I hopefully haven't included IPVS stuff into the nf-log patch, have
I? I don't seem to be able to find this change in your proposal.

>   - ip6t_log_target() was not properly renamed as ip6t_log_packet(), so
>     build was broken with IPv6 enabled.

I'll see to it, thanks. As you found out, I've never compiled my patches
with IPv6 selected; thanks for checking it.

> Please use the attached one as an update.

I will, once I get some time again to work on the kernel.

> I'm still in the process of building a new kernel with all this, I'll keep
> you informed.

Excellent.

Have a nice evening,
Roberto Nibali, ratz
-- 
echo
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
