From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch-o-matic problem
Date: Tue, 17 Feb 2004 00:16:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40314F67.4080104@eurodev.net>
References: <000801c3f4b9$8eb883d0$4900a8c0@racoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sandeep Singh Kohli <sskohli@vsnl.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <000801c3f4b9$8eb883d0$4900a8c0@racoon>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi!

Sandeep Singh Kohli wrote:

> hi
> i dunno whether i have to mail here
> i downloaded the latest path-o-matic version from the CVS
> I dunno whether there should be a sequence in which one midule 
> compiles over other..cos there were MANY problems while compiling the 
> kernel

you should pay attention because some patches could break others, so 
appliying all the patches is not a good idea.

> i mean whas the point in building a firewall when u had to comment out 
> majority of the code

patch-matic is a set of patches that are not included in the standalone 
version of netfilter/iptables because they are not considerated stable 
yet. So it's your responsability using them. In fact patch-o-matic-ng is 
still a work in progress.

best regards,
Pablo
