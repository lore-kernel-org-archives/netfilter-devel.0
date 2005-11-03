From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Unable to handle kernel NULL pointer dereference at virtual
 address 00000000 after conntrack -I
Date: Thu, 03 Nov 2005 20:55:37 +0100
Message-ID: <436A6B39.3080508@eurodev.net>
References: <Pine.LNX.4.63.0511031408370.32626@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.63.0511031408370.32626@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> # conntrack -I --orig-src 1.2.3.4 --orig-dst 1.2.3.5 --reply-src 2.3.4.5
> --reply-dst 2.3.4.5 -p tcp --orig-port-src 1 --orig-port-dst 2
> --reply-port-src 3 --reply-port-dst 4 -t 32323 -u ASSURED

--state option is missing: Unfortunately conntrack forgot to check it
that such parameter was missing and ctnetlink didn't do that check
either. That's why it resulted in an oops :(

I've just applied a patch for conntrack, refresh your working copy. So
you won't be able to reproduce that oops anymore.

Anyway I'll send a patch for ctnetlink, that checking must be done in
kernel space as well.

-- 
Pablo
