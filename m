From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [NETFILTER 04/39]: ipt_TCPMSS: reformat
Date: Wed, 20 Sep 2006 13:03:40 +0200
Message-ID: <4511200C.1040706@drugphish.ch>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
	<20060920082448.14636.28002.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, w@1wt.eu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20060920082448.14636.28002.sendpatchset@localhost.localdomain>
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

Patrick McHardy wrote:
> [NETFILTER]: ipt_TCPMSS: reformat
> 
> - fix whitespace error
> - break lines at 80 characters
> - reformat some expressions to be more readable

Would something like this be a candidate for 2.4 as well? When reading 
the code I often compare 2.6 and 2.4 kernel code and the more equal they 
look the easier it is.

OTOH, it's really not a bugfix and definitely not important.

Cheers,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
