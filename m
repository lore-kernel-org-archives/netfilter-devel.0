From: Max Kellermann <max@duempel.org>
Subject: Re: [report] H323 failed.
Date: Thu, 7 Apr 2005 17:49:58 +0200
Message-ID: <20050407154958.GA8737@roonstrasse.net>
References: <1112700374.26189.1.camel@sas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wojciech 'Sas' Ci?ciwa <cieciwa@dzp.ntt.com.pl>
Content-Disposition: inline
In-Reply-To: <1112700374.26189.1.camel@sas>
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

On 2005/04/05 13:26, Wojciech 'Sas' Ci?ciwa <cieciwa@dzp.ntt.com.pl> wrote:
>   CC [M]  net/ipv4/netfilter/ip_conntrack_h323.o
> net/ipv4/netfilter/ip_conntrack_h323.c: In function `h245_help':
> net/ipv4/netfilter/ip_conntrack_h323.c:110: error: structure has no
> member named `help'
[...]

Can you please provide the following information:
- which kernel version?
- which h323-conntrack-nat (pom-ng) version? are you using my patches
  from http://max.kellermann.name/projects/netfilter/h323.html ?

Max
