From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH-2.4-POM] replace flags test with lookups (was: CLOSE_WAIT..)
Date: Wed, 8 Oct 2003 18:32:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031008163212.GA2517@alpha.home.local>
References: <20031008131332.GA2135@alpha.home.local> <20031008151407.GA25743@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Willy Tarreau <willy@w.ods.org>,
   netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20031008151407.GA25743@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Oct 08, 2003 at 05:14:08PM +0200, Harald Welte wrote:
 
> Erm, are you aware of the
> http://cvs.netfilter.org/netfilter/patch-o-matic/submitted/81_ipt_unclean-tcp-flag-table.patch
> that has already been submitted for kernel inclusion?

Yes I am, but this one is against ipt_unclean while the one I just sent does
the same to ip_conntrack_proto_tcp after tcp_window_tracking. So the one you
point to is used with "-m unclean", while mine is used on every TCP packet
which goes through the conntrack code. But I agree it's exactly the same
(should we merge them in some ways ? I don't really think so). Where do you
believed I stole the code ? :-)

BTW, I've finally recompiled and tested it now. It's running fine, but seems to
exhibit no performance gain at all (OK, on average, mesured hits/s seem to be
less than 0.1% higher with the patch). I cannot decently attribute this to the
code, but mainly to measuring errors. So I'd say that it doesn't change things
for this type of machine machine (P3/800).

Willy
