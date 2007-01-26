From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch 1/2] libnfnetlink, iface conversion to string
Date: Fri, 26 Jan 2007 03:24:15 +0100
Message-ID: <45B9664F.8040606@netfilter.org>
References: <1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost>
	<45B0E24A.7040906@trash.net> <45B10222.1040806@netfilter.org>
	<20070122123618.GM9631@prithivi.gnumonks.org>
	<59155.90.13.189.211.1169586830.squirrel@mail.inl.fr>
	<45B80BFB.2060203@netfilter.org>
	<65031.80.214.249.17.1169727081.squirrel@mail.inl.fr>
	<20070125155908.GU16563@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070125155908.GU16563@prithivi.gnumonks.org>
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

Harald Welte wrote:
> There's only some really cosmetic point that I wnat to make: I believe
> it's not always within 80 characters wide lines (or is that just in the
> patch due to different tab expansion?).  But we can do that even after
> the commit ;)

Indeed, I just splitted some line to fit into 80 chars and remove some
blank lines, then I applied the patch to SVN.

Eric, have a look at Documentation/CodingStyle inside the kernel tree,
that is basically the same policy that the netfilter project follows for
everything inside and outside kernel, everyone will appreciate it ;)

BTW, I have inserted a test file under utils/ called iftable.c. I
introduced again two minor changes in the API since the last discussion
to keep it homogeneous with libnfnetlink:

int nlif_index2name(handler, index, name): Now you have to pass a buffer
of IFNAMSIZ where the interface name will be copied, better than the
previous that returns a pointer that needs to be "duplicated".

int nlif_query(handler): Call this function to request a whole dump of
the interface table, you have to call this after nlif_open, but someone
could call it elsewhere to request a whole resync with the interface table.

int nlif_catch(handle): Call this to update the table in the event of
changes

As Harald said, there are more cleanups still pending, like setting
errno to report errors, some possible const'ification, assertions,
probably move to linux_list interface instead of the array of pointers
to interface structures... Once we've solved this stuff I'll prepare
another libraries release.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
