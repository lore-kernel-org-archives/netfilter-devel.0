From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Packet Fragementation
Date: Tue, 30 Mar 2004 13:12:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40695616.9030809@eurodev.net>
References: <20040330110858.69086.qmail@web80809.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sara Kostandy <skostandy@yahoo.com>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <20040330110858.69086.qmail@web80809.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Sara,

Sara Kostandy wrote:

> We're developing an XML firewall application as part of our senior 
> graduation project. We are using Linux 2.4 and queuing packets to be 
> handled in user-space. However the packets arriving are fragmented, 
> and so are more difficult to deal with. Is there a way to defragment 
> them before they are queued to user-space??
>
In 2.4, the easiest way is loading the ip_conntrack module which will 
gather all the fragments and put them in a continuos memory area, this 
means that you won't need to deal with fragments anymore.

regards,
Pablo
