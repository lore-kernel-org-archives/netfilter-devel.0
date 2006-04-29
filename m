From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: condition for 2.6.16
Date: Sat, 29 Apr 2006 17:36:25 +0200
Message-ID: <200604291736.27030.max@nucleus.it>
References: <200604201919.19246.max@nucleus.it>
	<200604290253.49758.max@nucleus.it> <4452D5C8.6020007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4452D5C8.6020007@trash.net>
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

On Saturday 29 April 2006 4:56 am, Patrick McHardy wrote:
> > Nontheless, I think modifying userspace because 2 kernel functions can't
> > talk to each other is a bit silly.
> > It would be relatively easy to modify the kernel in order to support
> > instance data (extensive, but simple and relatively safe).
> > Do you think there would be a strong resistance to a patch in mainline
> > kernel?
>
> It is silly, but we have to live with it. I see two possibilities, one
> breaks userspace, one is extremly expensive. I like neither one.
> We should just add a clean netlink configuration interface modelled
> after the existing ones instead of building workarounds in this
> clearly broken interface. I mostly don't care about costs of a
> compatibility layer if we get a sane infrastructure in return.

I agree about the 2 non invasive (with respect to the mainline kernel) 
solutions.

If I could choose freely I would change these structures (and all 
corresponding references and initialization code) as follows:



struct xt_match
{
...
        int (*match)(const struct sk_buff *skb,
                     const struct net_device *in,
                     const struct net_device *out,
                     const void *matchinfo,
                     int offset,
                     unsigned int protoff,
                     int *hotdrop,
                     void *instance_data);

        int (*checkentry)(const char *tablename,
                          const void *ip,
                          void *matchinfo,
                          unsigned int matchinfosize,
                          unsigned int hook_mask,
                          void **instance_data);

        void (*destroy)(void *matchinfo,
                        unsigned int matchinfosize,
                        void *instance_data);
...
};


struct ipt_entry_match
{
...
	void *instance_data;
        unsigned char data[0];
};


This would solve the general problem of rule specific data (tracking, state, 
accounting, whatever).
It gives more expressiveness to the API in general and would have little 
impact on the parts of the code that do not use it (instance_data is 
initialized as NULL and never used).
The performance penalty would be negligible (4 or 8 more bytes in every 
descriptor and in every function call to the match function).

We could minimize impact on the existing code introducing a "normal" and an 
"extended" match funciton prototype, but this would crete complexity and its 
only purpose is if we don't want to upgrade everything.

The problem with my solution is:
- it's work (I could do it, so it's not your problem :));
- the kernel people may reject it or delay it for an extended period of time;
- while we the patch is available and the kernel people does not accept it 
we'll be stuck with 2 sets of incompatible netfilter APIs with all kinds of 
inconveniences while everyone updates their function declarations (we already 
survived one such change with 2.6.16).

I ask you these questions:
- is my proposal a desirable improvement?
- is there any other way or any additional improvement that we can do?
- would you support it for inclusion in mainline?
- would the kernel people like it?

If you think this is worth the trouble and promise to support the patch  for 
inclusion in mainline (at least after we agree to the implemetation details) 
I will start working on it.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
