From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] nfsim: Support more netfilter modules
Date: Tue, 13 Dec 2005 19:47:15 +0100
Message-ID: <439F1733.7010201@ingate.com>
References: <439ED1C5.7070103@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <439ED1C5.7070103@ingate.com>
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

Marcus Sundberg wrote:
> --- nfsim/kernelenv/include/kernelenv.h	(revision 6316)
> +++ nfsim/kernelenv/include/kernelenv.h	(working copy)
> @@ -1166,6 +1177,10 @@
>  
>  static inline void smp_read_barrier_depends(void) {;}
>  
> +/* delay.h */
> +
> +#define msleep(x)	do{unsigned int y = (x)*1000; usleep(y);}while(0)
> +
>  /* timer.h */
>  
>  /* not used at the moment */

Hmm, actually I guess something like:

#define msleep(x)	increment_time((x)*HZ/1000)

would make more sense. Comments (on this or the original patch)?

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
