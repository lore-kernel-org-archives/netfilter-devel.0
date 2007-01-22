From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: PANIC: divide by zero in xt_connbytes
Date: Mon, 22 Jan 2007 09:52:50 +0100
Message-ID: <200701220952.50417@nienna>
References: <45AF5318.8040204@outerspace.dyndns.org>
	<45AF7861.5000201@outerspace.dyndns.org>
	<200701181522.37984@nienna>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200701181522.37984@nienna>
Content-Disposition: inline
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


  Hi,

> > I initially suggested that too and would have renamed the function to
> > div64_64_safe() or similar in the same go.. but Hidden (on irc)

  As a side note: since counters have been changed to 32 bits, I think 
this div64_64 function is not necessary anymore. (Yes, I have read the 
discussion about reintroducing them, but that won't be in 2.6.20 I 
guess.)

-- 
 Regards,
  Krisztian Kovacs
