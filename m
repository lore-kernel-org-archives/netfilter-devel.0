From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFCT_Q_DUMP problem
Date: Wed, 14 Mar 2007 14:17:10 +0100
Message-ID: <45F7F5D6.8070904@netfilter.org>
References: <45F4B34F.3020007@ipom.com> <45F527F2.40404@netfilter.org>
	<45F6558A.2070601@ipom.com> <45F671CA.6010401@netfilter.org>
	<45F7A20A.5050302@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F7A20A.5050302@ipom.com>
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

Phil Dibowitz wrote:
> Pablo Neira Ayuso wrote:
>> BTW, I suggest you to have a look a new_api_test.c under utils/ to get
>> quick look on the new API. The old API is deprecated and will vanish
>> sooner or later, new apps must use the new API.
> 
> So I sat down to write some test code today on the new API, and I found all
> the nice getter functions, which are awesome... but I can't seem to make the
> new API work with NFCT_Q_DUMP. I shrunk down my test the bare minimum and
> nfct_query *always* returns errno for "Address family not supported by
> protocol" :(
> 
> new_api_test.c doesn't test the NFCT_Q_DUMP query, so I'm wondering if it's
> perhaps a problem in the NFCT_Q_DUMP query type.
> 
> Here's some sample code:
> [...]
>         res = nfct_query(cth, NFCT_Q_DUMP, ct);
                                              ^^^
u_int8_t family = AF_INET;
res = nfct_query(cth, NFCT_Q_DUMP, &family);

Extracted from the API docs:

  * The pointer to data can be a conntrack object or the protocol family
  * depending on the request.
  *
  * For query types:
  *      NFCT_Q_CREATE
  *      NFCT_Q_UPDATE
  *      NFCT_Q_DESTROY
  *      NFCT_Q_GET
  *
  * Pass a valid pointer to a conntrack object.
  *
  * For query types:
  *      NFCT_Q_FLUSH
  *      NFCT_Q_DUMP
  *      NFCT_Q_DUMP_RESET
  *
  * Pass a valid pointer to the protocol family (u_int8_t)

I'm thinking about changing this to use va_list, thus not needing to 
pass &family which is a bit ugly. This is one of the minor nitpicks of 
the new API that I'd like to improve.

BTW, when do you plan to release your application?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
