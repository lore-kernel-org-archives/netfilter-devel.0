From: Pablo Neira <pablo@eurodev.net>
Subject: Re: modifications for SMP processor
Date: Wed, 04 Aug 2004 13:11:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4110C46B.6000100@eurodev.net>
References: <PAEMKCJPEJFAMHHIJGBOCELBMLAB.laurent.schweizer@eivd.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laurent Schweizer <laurent.schweizer@eivd.ch>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <PAEMKCJPEJFAMHHIJGBOCELBMLAB.laurent.schweizer@eivd.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Laurent,

laurent Schweizer wrote:

>I am writing a target for iptables.
>
>My target has a table and I see that it is not working correctly on SMP
>processor.
>  
>

well, that's not enough info. Anyway, if all iptables rules are sharing
that table (I mean that table is defined inside the target as a global
var), I guess that you need reader/writer lock.

On the other hand, if the table is inside the target's private
information, that's different... you should have a look at ipt_limit.c
for a reference.

>I want to know which modifications I must make, or where I can find an
>example.
>  
>

Robert Love has written a good article about this:
http://www.linuxjournal.com/article.php?sid=5833

Check out also Rusty's unreliable guide for locking in the kernel.

regards,
Pablo
