From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] NAT tuple reservation
Date: Fri, 28 Nov 2003 16:06:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FC76485.5000202@balabit.hu>
References: <3FB8DF90.5090505@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3FB8DF90.5090505@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

KOVACS Krisztian wrote:
> ip_nat_setup_info_reserved(...): This is basically the same as 
> ip_nat_setup_info, except that it calls ip_nat_setup_info() with the 
> appropriate flag, and deletes the reservation in case of successful 
> allocation.

   Oh, one more question, suggested by Nikolai Dahlem: to be able to 
decide if ip_nat_setup_info() may allocate a reserved tuple, we need some 
kind of additional argument (flags). However, ip_nat_setup_info() is 
called from a number of places, for example NAT helpers. So, modifying 
ip_nat_setup_info() would mean those calls need to be updated.

   Nikolai suggested we could provide an ip_nat_setup_info_extended() 
function, and make ip_nat_setup_info be a simple call with the default 
flags. However, I feel that this flags attribute could be used more 
universally, for example, our transparent proxying patch already adds it, 
and uses it actively to bypass calling helpers.

   So, the question is: what about extending ip_nat_setup_info() with an 
additional flag attribute in the NAT core? Or should we stay with a 
"workaround" for now?

-- 
   Regards,
     Krisztian KOVACS
