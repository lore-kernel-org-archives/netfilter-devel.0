From: "kesineni sai pratap" <kesineni@woojininc.net>
Subject: how to route the packet in my case
Date: Sat, 7 Aug 2004 10:16:03 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000c01c47c1c$1bb14f30$0201020a@kesineni>
References: <20040806115856.29384.42526.Mailman@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Guys ,

I have some problem , to route the packet

i made network like this

10.2.1.2 and 10.2.1.3 are in same network. 10.2.1.2  gateway is 10.2.1.3.
10.1.1.30 gateway is 10.1.1.254.

10.1.1.30 have three interfaces , first interface goes to 10.1.1.254, second
interface goes to 10.2.1.3 , third interface goes to 10.2.1.2.  10.2.1.2 and
10.2.1.3 are bridged.  if bridge is enabled packet s from 10.2.1.2 go
through bridge to reach 10.2.1.3.

But my requirement is i want send 10.2.1.2 packets to routing module to send
the packets to 10.2.1.3.

iam finding way 10.2.1.2 packets to reach 10.2.1.3, iam getting problem in
ip_route_input_slow() because



another step is  if(err = fib_lookup(&key,&res))!=0)
                        {
                            if(!IN_DEV_FORWARD(in_dev))
                                  goto e_inval;
                            goto no_route;
                         }

this steps , my system hang out.


How can i over come this problem

anybody help me

bye
sai pratap kesineni
