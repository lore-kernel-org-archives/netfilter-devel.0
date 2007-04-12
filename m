From: "Mohammad Mohsenzadeh" <mmohsenz@gmail.com>
Subject: Re: 2.6.20 support for other 'features'
Date: Thu, 12 Apr 2007 18:49:27 -0400
Message-ID: <e6af3bc80704121549g44dfb1bct8a8a735a2d6dc67f@mail.gmail.com>
References: <e6af3bc80704111039x322e55e5qe1ea1568b59214b0@mail.gmail.com>
	<461D2033.2030508@trash.net>
	<e6af3bc80704111114lea2aafdg281b8599b2d34996@mail.gmail.com>
	<461D2748.4050000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461D2748.4050000@trash.net>
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
> Mohammad Mohsenzadeh wrote:
> > On 4/11/07, Patrick McHardy <kaber@trash.net> wrote:
>
> >> Actually on second thought, I don't think this can even work.
> >> The features and the resulting memory layout of struct nf_conn
> >> need to be coordinated for all different combinations, so
> >> you can at most extend it by one, which would always come at
> >> the end.
> >>
> >
> > That should be find. The layout will be like the following
> > feature #        layout
> > 4                   nf_conn .. extra
> > 5                   nf_conn .. helper .. extra
> > 6                   nf_conn .. nat .. extra
> > 7                   nf_conn .. nat .. helper .. extra
> >
> > and so on. Therefore you can have as many features as you want. It
> > just extends the 'extra' part above.
>
> And how would it do that for two external modules, that don't know
> how large the last part is?
>

That's absolutely correct. How about having only one slab cache and a
dynamic list of features. Whenever a new feature is registered or an
old one is removed, we can reallocate slab cache with a new size. I'm
not sure if that would work for sure, just throwing some ideas out
there. Something like

struct nf_conntrack_feature {
    struct list_head list;

    /* name of feature */
    unsigned char name[NF_CT_FEATURES_NAMELEN];

    /* size of feature */
    size_t size;

    /* feature offset for private data */
    size_t offset;

    /* modules which use this feature */
    int use;
};

static struct {
    /* dynamic list of features */
    struct list_head features;

	/* size of slab cache */
	size_t size;

	/* slab cache pointer */
	struct kmem_cache *cachep;

} nf_ct_cache;


One problem that I can see with this is that we have flush all our
conntracks so we can call 	kmem_cache_destroy and then recreate the
slab with new size. Would this be alright since it would only happen
on registering and unregistering features since it doesn't happen
often.

Mohammad
