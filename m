From: "Hime Junior" <hime@engineer.com>
Subject: Re: [PATCH 2] Re: what's the lockingrules for ip_conntrack_expect
    _list?
Date: Mon, 14 Oct 2002 08:35:23 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014133524.75717.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: li9@expert.ics.purdue.edu
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 Hi ,

 I believe the following book (by Rubini and Corbet) may be helpful in the module programming part of the task ...

 It´s free and very well written .

 If you have interest , just follow the link  

 http://www.oreilly.com/catalog/linuxdrive2/

 to the online book .


           Regards .


----- Original Message -----
From: Min Li <li9@expert.ics.purdue.edu>
Date: Sat, 12 Oct 2002 09:59:56 -0500 (EST) 
To: 
Subject: Re: [PATCH 2] Re: what's the lockingrules for ip_conntrack_expect_list?


> 
> Dear All,
> 
> I have to implement one senario which is to differentiate traffic coming
> through the router. For any new connections forwarded by the router, I
> have to change the source address of those packets. Also, the new
> source addresses are known at user space only. So, by simply using
> iptables NAT table, I won't be able to do that. In my application, I plan
> to inform the kernel about the new source addresses, and then create a
> address mapping table in the kernel. Then add a new module in iptables to
> take care of specially my scenario. So, in the kernel, I will do all the
> address translation based on the connection tracking results. However,
> that means I need to change iptables tool as well as adding a new module.
> I have never done linux kernel module programming before. Will it be
> possible for you to give me some advice?
> 
> Thanks a lot.
> 
> Min
> 
> 
> 
> 




                    Hime Junior
            ___________________________
  
          Electronic and Control Engineer


-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

"Free price comparison tool gives you the best prices and cash back!"
http://www.bestbuyfinder.com/download.htm
