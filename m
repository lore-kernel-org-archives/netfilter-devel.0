From: Ian Norton <bredroll@darkspace.org.uk>
Subject: Re: ipsec implementation using netfilter
Date: Sat, 19 Mar 2005 11:31:37 +0000
Message-ID: <20050319113137.GA28048@earth.dsh.org.uk>
References: <20050319065622.45027.qmail@web31402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: avinash m <kukzme@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20050319065622.45027.qmail@web31402.mail.mud.yahoo.com>
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

Hi there,

I Have recently (almost) completed work on building an ipcomp implementation
using netfilter to handle packet input. It works, but have you ever heard of a
'filter' that lets stuff through and makes it bigger or smaller :-) 

In the same way as IMQD is used for ingress and egress queuing, it 'is'
possible to do these things in netfilter but it really isnt the place to build
this sort of thing, (my ipcomp system happily interoperates with the 2.6ipcomp
on other machines but really doesnt make sense when observing packets at my end
with ethereal)

building another driver maybe called hw_ipsec shouldnt be that hard, i should
imagine it would have the same interfaces to the kernel as the current ipsec.

Ian

On Fri, Mar 18, 2005 at 10:56:21PM -0800, avinash m wrote:
> Hi 
> 
>   I am a newbie trying to implement ipsec in transport
> mode. i am new to writing networking code too.
> 
> The crypto algorithms are actually implemented on a
> crypto accelerator card which can be programmed using
> some registers to setup an encryption/decryption
> sessions. The security associations are also stored in
> the crypto card.  
> 
> I have seen the openswan.org but that didnt get me
> anywhere. I am also not clear hoe i could place this
> customization into the existing ipsec stack(if i could
> understand that)
> 
>  Now i am of the idea of implementing this using the
> netfilter module. I am planning to place hook on the
> loca input and local output hooks. The packets are
> then sent to the card for enc/dec.
> 
> I this the right way to implement? if not could i get
> some pointers to do this the right way.
> 
> Thanx in advance.
> shawn
> 
> 
> 		
> __________________________________ 
> Do you Yahoo!? 
> Yahoo! Small Business - Try our new resources site!
> http://smallbusiness.yahoo.com/resources/ 
> 

-- 
Ian Norton-Badrul
