From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Tue, 25 May 2004 19:45:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B3863F.6040105@trash.net>
References: <Pine.LNX.4.33.0405211416341.8045-100000@blackhole.kfki.hu> <40AF6A60.70406@trash.net> <40B33E37.4070807@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40B33E37.4070807@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> if we use atomic operations *_bit for status field in ip_conntrack, we 
> only use 24 bits of that unsigned long, this issue lets us keep 
> compatibility with some special platforms which only support atomic 
> operations of that size.
>
> I read that in  Robert Love's linux kernel development book I think. 
> If missing anything, please let me know.


This applies to atomic_t and atomic_inc, atomic_dec_and_test, etc., but 
not to set_bit/test_bit.
It can operate on bitmaps larger than unsigned long, but I don't know if 
it will cause problems
with smaller types.

Regards
Patrick
