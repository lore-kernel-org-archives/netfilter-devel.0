From: "Andrew Smith" <nfml@k1k2.com>
Subject: Re: performance issues (nat / conntrack)
Date: Sat, 29 Jun 2002 15:25:50 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <40827.203.134.158.15.1025328350.squirrel@iw.k1k2.com>
References: <20020627112448.GC9003@naboo.rchrd.phub.net.cable.rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
In-Reply-To: <20020627112448.GC9003@naboo.rchrd.phub.net.cable.rogers.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> On Thu, Jun 27, 2002 at 12:21:45PM +1000, Andrew Smith wrote:
>> This gives a good example when being able to set the timeout dependant
>> upon specific factors (e.g. port/protocol) would be good rather than a
>> global timeout that suits specific cases and does not match many cases
>> - and causes a severe problem for a limited set of cases
> 
> Sorry, but we've had this discussion over and over again. Go to the
> list archives and look for tuneable timeouts.
> 
> The conclusion of this discussion was, that we need to cope with all
> cases without any tuning being necessarry. 

Well either there is a language mistake or that statement is rubbish.
It does NOT cope with all cases.
If fails dismally with the case I've given.
It is not POSSIBLE to cope with all cases without any tuning being
necessary unless the code tuned itself.

Pity that the conclusion is flawed.

> btw: For the 'ping' case, the icmp echo reply is closing the connection
> anyway.

So I guess I need to look in detail what is happening in my case
- but at a guess the problem might be that a large number of the
connections fail to get a fast enough response and thus do not get
closed for a 'long' time.

> conntrack is mostly about tracking layer 3+4 protocol state.  And this
> should happen as transparent as possible, so assumptions about the
> application are made.  [conntrack helpers are an exemption, and be sure
> I would be much happier if we didn't need to have them].
> - Harald Welte / laforge@gnumonks.org              

Yes but the problem is that it causes problems at a higher protocol
level and though it works for most cases - it fails on at least a
few specific cases.

Anyway - this argument will not get anywhere.
I guess some time (in the far distant future :-) when I have the
time and inclination I'll fix it myself and then just have to keep
patching it every time it's updated - coz the comments certainly
suggest that a patch would not be accepted here.

-- 
-Cheers
-Andrew

MS ... if only he hadn't been hang gliding!
