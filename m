From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Illegal option `-i' with conntrack -I
Date: Thu, 3 Nov 2005 15:07:52 +0100
Message-ID: <200511031507.52812@nienna>
References: <Pine.LNX.4.63.0511031427190.1341@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.63.0511031427190.1341@bizon.gios.gov.pl>
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

On Thursday 03 November 2005 14.36, Krzysztof Oledzki wrote:
> It seems it is not possible to specify conntrack id while adding new
> conntrack. Is it intentionally?
>
> # conntrack -I --orig-src 1.2.3.4 --orig-dst 1.2.3.5 --reply-src
> 2.3.4.5 --reply-dst 2.3.4.5 -p tcp --orig-port-src 1 --orig-port-dst
> 2 --reply-port-src 3 --reply-port-dst 5 -t 32323 -u ASSURED -i 99
> conntrack v0.95: Illegal option `-i' with this command
> Try `conntrack -h' or 'conntrack --help' for more information.

  I guess it's intentional. For the netlink dump to work you need the 
IDs of conntrack entries to be unique and monotonously increasing, and 
that's what setting the ID from userspace could ruin.

-- 
 Regards,
  Krisztian Kovacs
