From: Patrick McHardy <kaber@trash.net>
Subject: Re: [MATCH] a match for qq
Date: Fri, 21 Jul 2006 01:39:54 +0200
Message-ID: <44C0144A.6060604@trash.net>
References: <1153176704.15818.1.camel@localhost.localdomain>	
	<44BFAEA4.5070507@trash.net>
	<1153366270.24974.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter dev <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: zhongyu@18mail.cn
In-Reply-To: <1153366270.24974.7.camel@localhost.localdomain>
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

zhongyu wrote:
> Ofcause, and I had added the msn support for this match, so the module
> name was changed to ipt_im. I will search the STL protocol and add the
> GoogleTalk support soon (my current idea is match the STL
> certifacation's common name).
> The new code is here
> http://www.18mail.cn/ipt_im.tgz

You need to publish an index file for a pomng repository.

Check out one of the existing repositories for examples:

# geoip, maintained by Samuel Jean <jix@bugmachine.ca>
http://mynodes.net/pub/linux/netfilter/patchlets

# condition, maintained by Massimiliano Hofer <max@nucleus.it>
http://www.nucleus.it/pom-repo

# ipp2p and time maintained by Krzysztof Oledzki <ole@ans.pl>
http://people.netfilter.org/ole/pom/
