From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: netfilter & ipv6
Date: Thu, 10 Feb 2005 16:07:15 +0200
Message-ID: <420B6A93.3080005@niksula.hut.fi>
References: <42086F50.9090504@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42086F50.9090504@niksula.hut.fi>
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

Jonas Berlin wrote:

> 3. If I succeed porting something, what should I name the patch to be 
> sent to patch-o-matic-ng? I don't think I could just extend the 
> existing ones as that would suggest the original authors have 
> something to do with it and also some of them also are pending or 
> already included in the ekernel. So, would CLASSIFY_v6 be an 
> acceptable name for the ipv6 version of CLASSIFY?

After twisting some bits around, my CLASSIFY_v6 seems to work 
succesfully, however the naming is awkward since the name of the name of 
the module essentially determines the name of the target, the module 
etc. So one has to write

  ip6tables ... -j CLASSIFY_v6 --set-class 1:20

Although this works fine, having some modules with suffix _v6 and some 
not is just plain confusing. Is there any way to reuse the CLASSIFY for 
ipv6 name without conflicting with the CLASSIFY module already in pom? 
Maybe I missed something?

-- 
- xkr47
