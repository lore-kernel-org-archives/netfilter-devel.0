From: "Srinivas Krishnan" <shrin.krishnan@gmail.com>
Subject: Re: Packet Delay using Netfilter
Date: Thu, 20 Apr 2006 15:35:31 -0400
Message-ID: <ba7fdfc10604201235l166d440ue20e2713e3db43c0@mail.gmail.com>
Reply-To: krishnan@cs.unc.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

I am trying to do it filter packets by flow and add delay to each
flow. Netfilter just seemed an easier way of doing it without getting
into the complications of qdiscs.

-shrin

Patrick McHardy wrote:

>Why are you not doing this on the qdisc layer?
