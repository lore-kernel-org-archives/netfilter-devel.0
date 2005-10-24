From: Pablo Neira <pablo@netfilter.org>
Subject: Re: [PATCH] autogen.sh for libnetfilter_conntrack
Date: Tue, 25 Oct 2005 01:51:20 +0200
Message-ID: <435D7378.5090206@netfilter.org>
References: <1130141237.11255.4.camel@localhost.localdomain>
	<1130141444.11255.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	gryzor@inl.fr
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eleblond@inl.fr>
In-Reply-To: <1130141444.11255.10.camel@localhost.localdomain>
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

bonjour Eric,

Eric Leblond wrote:
> I've just added a "libtoolize -f" call to autogen.sh. It was not
> compiling cleanly from svn without that.

AFAIK, autoreconf is supposed to supersede autogen.sh-like scripts. That 
is what I've used so far. Is there any extra reason why someone could 
need autogen.sh?

Anyway I'll apply your patches, my guess is that other users will be 
complaining about the autogen.sh file missing sooner or later.

cheers,
Pablo
