From: "Hime Junior" <hime@engineer.com>
Subject: Re: Merge of iptables 'fuzzy', 'random' and 'nth' match
Date: Mon, 25 Aug 2003 08:17:33 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825131733.54892.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: "Harald Welte" <laforge@netfilter.org>, fabrice@netfilter.org,
	rwagner@cloudnet.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Dear friends:

 I think that "ipt_statistical" is not adequate for a container of the fuzzy match , taking into account that Fuzzy Logic is a branch of the so called Soft Computing or Computational Intelligence , not Statistics .
 There is a statistical flavor in the implementation of the fuzzy patch indeed , but only for design reasons - it could be made without any statistical tools .
 So , I ask you to keep the decision to include the fuzzy match in the new kernel but as a standalone module - for the best of my knowledge , iptables 
is the only "fuzzified" firewall in existence today , and I intend to do additional work to provide more code using FL techniques . I just had no time to do that, but I´m going to ...
 
 Thank you very much !

----- Original Message -----
From: Harald Welte <laforge@netfilter.org>
Date: Sun, 24 Aug 2003 09:21:58 +0200 
To: hime@engineer.com, fabrice@netfilter.org, rwagner@cloudnet.com
Subject: Merge of iptables 'fuzzy', 'random' and 'nth' match

> At the netfilter developer workshop, it was decided that we would like
> to include the functionality of the fuzzy, random and nth match into the
> upcoming 2.6 mainstream kernel.
> 
> However, it is doubtful that each of those three features really need 
> their own module.
> 
> We'd like to ask you to merge the three modules into one
> ipt_statistical.c module, that can be used in 'nth', 'random' or 'fuzzy'
> mode.
> 
> If you would work together on this issue (or one of you wants to take up
> this job), I would be very happy to submit the result for kernel
> inclusion.
> 
> [btw: the same goes for the IPv6 counterpart - but that 'port' can
> follow later on]
> 
> Thanks.
> 
> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie




                    Hime Junior
            ___________________________
  
          Electronic and Control Engineer


-- 
__________________________________________________________
Sign-up for your own personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

CareerBuilder.com has over 400,000 jobs. Be smarter about your job search
http://corp.mail.com/careers
