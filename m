From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Userspace queuing
Date: Fri, 25 Jun 2004 22:27:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40DC8A97.4060805@eurodev.net>
References: <200406251811.i5PIBlMX013526@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <200406251811.i5PIBlMX013526@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Muhammad,

Muhammad R. Sami wrote:

>Is there a way to perform userspace queuing in iptables? If yes can I have
>some example codes.
>  
>

http://www.cs.princeton.edu/~nakao/libipq.htm
^^^
I think that you could be able to get it running with the information 
provided in the manpage.

http://cvs.netfilter.org/netfilter/testsuite/tools/intercept.c
^^^
This is an old example, I got it compiled with no big problems.

best regards,
Pablo
