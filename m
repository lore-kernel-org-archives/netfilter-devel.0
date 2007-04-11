From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.20 support for other 'features'
Date: Wed, 11 Apr 2007 19:49:30 +0200
Message-ID: <461D1FAA.1080100@trash.net>
References: <e6af3bc80704111039x322e55e5qe1ea1568b59214b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Mohammad Mohsenzadeh <mmohsenz@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <e6af3bc80704111039x322e55e5qe1ea1568b59214b0@mail.gmail.com>
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

Mohammad Mohsenzadeh wrote:
> I have been developing extension for netfilter to allow stateful
> firewall and filtering. I was looking at the new api in 2.6.20 and I
> was wondering why the number of 'features' allowed is maxed to 4.
> 
> I was thinking of configuration number of features and maybe some way
> of setting a default feature to use instead of NF_CT_F_BASIC. This way
> the netfilter can easily be extended. I can provide a patch if you
> think the above is a good idea.


Lets see the patch to decide whether this is a good idea :)

But the feature stuff needs to be reworked in the not too distant
future, its impossible to properly determine what features might
be used in the future at allocation time, which is why we always
allocate for the worst case anyway and still can't properly deal
with the NAT module being loaded late.
