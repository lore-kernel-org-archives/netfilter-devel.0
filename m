From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [CTNETLINK] Rework conntrack fields dumping logic on events
Date: Mon, 13 Nov 2006 00:42:15 +0100
Message-ID: <4557B157.6010205@netfilter.org>
References: <4553D3D5.40408@netfilter.org>
	<Pine.LNX.4.64.0611102151300.26087@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0611102151300.26087@blackhole.kfki.hu>
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

Hi Jozsef,

Jozsef Kadlecsik wrote:
> On Fri, 10 Nov 2006, Pablo Neira Ayuso wrote:
> 
>> This patch also replace IPCT_HELPINFO by IPCT_HELPER since we want to
>> track the helper assignation process, not the changes in the private
>> information held by the helper.
> 
> Actually, how it is solved to pass the setting of dynamically assigned 
> (i.e. currently not registered) helpers? What about registering such 
> helpers with non-matching address/proto/port parameters?

I'm unsure that I understand the question. Currently ctnetlink cannot
assign a helper that is not registered. Therefore, in order to register
a helper with non-matching parameter, wouldn't we need a new parameter
at modprobe stage? Perhaps some kind of userspace tool to manage helper
matching parameters could be interesting.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
