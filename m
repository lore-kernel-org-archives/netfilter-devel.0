From: "Mohammad Mohsenzadeh" <mmohsenz@gmail.com>
Subject: Re: 2.6.20 support for other 'features'
Date: Wed, 11 Apr 2007 14:14:30 -0400
Message-ID: <e6af3bc80704111114lea2aafdg281b8599b2d34996@mail.gmail.com>
References: <e6af3bc80704111039x322e55e5qe1ea1568b59214b0@mail.gmail.com>
	<461D2033.2030508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461D2033.2030508@trash.net>
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

On 4/11/07, Patrick McHardy <kaber@trash.net> wrote:
>
> But the feature stuff needs to be reworked in the not too distant
> future, its impossible to properly determine what features might
> be used in the future at allocation time, which is why we always
> allocate for the worst case anyway and still can't properly deal
> with the NAT module being loaded late.

We would still have this problem (even worse), because we would never
know what or how many features will be registered by other modules. At
least right now, we know the worse case is 4 when both nf_nat and
nf_helper are registered. But we could perhaps have a module parameter
to specify the worse case. Something like
      insmod nf_conntrack nf_conntrack_max_features=8

>
> Actually on second thought, I don't think this can even work.
> The features and the resulting memory layout of struct nf_conn
> need to be coordinated for all different combinations, so
> you can at most extend it by one, which would always come at
> the end.
>

That should be find. The layout will be like the following
feature #        layout
4                   nf_conn .. extra
5                   nf_conn .. helper .. extra
6                   nf_conn .. nat .. extra
7                   nf_conn .. nat .. helper .. extra

and so on. Therefore you can have as many features as you want. It
just extends the 'extra' part above.

I also try to post the patch here shortly.

Mohammad
