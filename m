From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Table-based branching
Date: Mon, 05 Apr 2004 17:37:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1081179473.1200.29.camel@nienna.balabit>
References: <200404051727.13704.mailinglists@futureware.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: pg@futureware.at
In-Reply-To: <200404051727.13704.mailinglists@futureware.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Mon, 2004-04-05 at 17:27, Philipp Gühring wrote:
> My idea now is to have different rule tables for allowed and disallowed IP 
> addresses, and special kernel module that branches into either rule table.
> That module contains a large Bit-Array in kernel memory to store for every IP 
> addresse whether it is allowed or disallowed.
> 
> Has anyone done that before (or something similar)?

  Of course! Take a look at the old ippool, or the new ipset module.
(Modules 'pool' and 'set' in Patch-o-matic-NG.) The ippool module does
exactly what you described, the ipset addon by Jozsef Kadlecsik is much
more powerful.

-- 
 Regards,
   Krisztian KOVACS
