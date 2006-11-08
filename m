From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] new API for libnetfilter_conntrack
Date: Wed, 08 Nov 2006 20:44:27 +0100
Message-ID: <4552339B.7080008@netfilter.org>
References: <45456285.4010609@netfilter.org> <20061107192458.GJ4423@(none)>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Eric Leblond <eric@inl.fr>
In-Reply-To: <20061107192458.GJ4423@(none)>
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

Harald Welte wrote:
> One option would be implement the subsystem specific parts as plugins
> and to dlopen() them at runtime, providing a way of updating only
> individual subystem-plugins

I like this option

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
