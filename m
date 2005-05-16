From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: QUEUE target and IPT_CONTINUE verdict ?
Date: Mon, 16 May 2005 07:03:01 -0400
Message-ID: <876ef97a05051604033d6e8bbb@mail.gmail.com>
References: <200505131729.39430.laurent.guyon@adelux.fr>
	<876ef97a05051510053c6827c2@mail.gmail.com>
	<Pine.LNX.4.61.0505152244290.28907@filer.marasystems.com>
	<876ef97a05051515127fbbf066@mail.gmail.com>
	<Pine.LNX.4.61.0505160849470.14981@filer.marasystems.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0505160849470.14981@filer.marasystems.com>
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

On 5/16/05, Henrik Nordstrom <hno@marasystems.com> wrote:
> Why do you want more than one ip_queue handler, and how?

I don't. I had just wondered as to the reason there was only one
ip_queue handler allowed and when you explained the above, I figured
that was the reason. Multiplexing ip_queue in userspace over multiple
handlers is trivial; I don't see the need for more than one handler,
given the complexity that it would add to the kernel to implement
such.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
