From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: limiting bandwidth using qdisc alone
Date: Tue, 13 Jul 2004 02:40:30 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407122338.i6CNcNMX003228@madinah.ccse.kfupm.edu.sa>
References: <876ef97a04071216243a36bd78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Tobias DiPasquale'" <codeslinger@gmail.com>
In-Reply-To: <876ef97a04071216243a36bd78@mail.gmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Well hello Tobias, I will give you the entire picture once it is all done
from my side, for the mean while it would be nice of you if you can simply
answer my question.
Regards,

Muhammad R. Sami 
Research Assistant, 
Computer Engineering Department 
P.O.Box 354 
King Fahd University of Petroleum & Minerals 
Dhahran 31261 
Saudi Arabia. 
Tel: +96638601423 
Cell: +96657982951 
www.ccse.kfupm.edu.sa/sami

-----Original Message-----
From: Tobias DiPasquale [mailto:codeslinger@gmail.com] 
Sent: Tuesday, July 13, 2004 2:24 AM
To: Muhammad R. Sami
Subject: Re: limiting bandwidth using qdisc alone

On Tue, 13 Jul 2004 02:05:44 +0300, Muhammad R. Sami
<sami@ccse.kfupm.edu.sa> wrote:
> I want to limit the bandwidth of my outgoing interfaces for all traffic
but
> do not want to use shapecfg and shaper. My question is that can I use
qdisc
> instead. As far as my understanding, I just have to specify a qdisc
> (preferably HTB) on the interface, limit the bandwidth and allow all
traffic
> to go through it, without any iptables marking. Is this possible and
> efficient way to do what I want? Or does anybody have a better solution
for
> this?

Ok, I'll bite: what is it that you want to do with all of this? You've
been asking numerous questions on a number of lists and clearly you
have a good idea of what the end result of all this is supposed to be.
Perhaps if you shared the whole concept with us, we'd be better able
to help you with the particular technologies you need to make it
happen.

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
