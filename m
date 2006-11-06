From: "will_u_tellmemore will_u_tellmemore" <will.u.tellmemore@gmail.com>
Subject: HowTo: Intercept every packet sent to TCP layer by IP layer and
	logging them in user space.
Date: Mon, 6 Nov 2006 16:16:41 +0530
Message-ID: <97993dc40611060246t57ccbb65w7721d92482d431ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi All,

I read some of the documents about this but could not figure out
exactly how to do this :
   Intercept every packet sent to TCP layer by IP layer and logging
them in user space.
If somebody could answer following question that will be a great help.

1: Does netfilter framework allows to intercept packet at this level directly.??
2: Registering a hook with   NF_IP_LOCAL_IN is what i need to do ??
3: Can logging task be handled by ulogd . My module will sent data to
a user app which will be   developed using ulogd ??

Any help or just a pointer to links where i can find this info would
also be of gr8 help.

Regards,
jay
