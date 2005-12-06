From: Aleksandar Milivojevic <alex@milivojevic.org>
Subject: Re: TCPMSS is not restricted to mangle table
Date: Mon, 05 Dec 2005 22:30:25 -0600
Message-ID: <439513E1.3060407@milivojevic.org>
References: <4393895D.1020106@trash.net> <20051205004548.GC5617@eychenne.org>
	<439393C9.5020001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <439393C9.5020001@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Patrick McHardy wrote:

> Thanks, I didn't know this, I'm going to change this to refer to
> the mangle table. This still leaves the option of a warning, but
> want I really wanted to know was whether anyone cares. From a
> consistency point of view it should be restricted, for the
> functionality it doesn't matter.

 From consumer (of your code) point of view, I do care.  The current 
documentation was clearly encouraging (by example) use of TCPMSS from 
filter table.  My guess is that majority of production systems using 
TCPMSS target are using it from filter table.  If the only reason is 
consistency (nothing is going to be fixed by the change, and nothing is 
going to be broken by leaving it as is), a warning now (in manual page, 
right next to the example) and change on next major kernel release (2.7) 
might be the best approach.  I'd leave things as is for 2.6 series of 
kernels.

Just my 2 cents.
