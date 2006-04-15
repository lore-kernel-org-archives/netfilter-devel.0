From: Dmitry Mishin <dim@sw.ru>
Subject: Re: compat_xt_counters is not compatible
Date: Sat, 15 Apr 2006 22:38:37 +0400
Message-ID: <200604152238.37403.dim@sw.ru>
References: <jeacaoqdxn.fsf@sykes.suse.de> <200604152014.45923.dim@sw.ru>
	<je64lakam1.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andreas Schwab <schwab@suse.de>
In-Reply-To: <je64lakam1.fsf@sykes.suse.de>
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

I believes, that on 32 bit arch any alignment <= 4 bytes. Could you point out 
the cases, where it is not true?

On Saturday 15 April 2006 21:32, Andreas Schwab wrote:
> Dmitry Mishin <dim@sw.ru> writes:
> > Could you give more details on what's wrong?
>
> Your claim that long long has 4 byte alignment.
>
> Andreas.

-- 
Thanks,
Dmitry.
