From: "Srinivas Krishnan" <shrin_krishnan@yahoo.com>
Subject: Packet Delay using Netfilter
Date: Thu, 20 Apr 2006 12:45:55 -0400
Message-ID: <ba7fdfc10604200945v417f2689wef8709d59b67a1c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

  Hi ,

I am trying to create a module that adds delay to certain egress
packets. I am using the NF_IP_POST_ROUTING hook. The question I had
was that can I set NF_STOLEN and call dev_queue_xmit( ) directly or
should I call dev_hard_xmit ( ). the reason I am setting NF_STOLEN, is
because I do not want netfilter to wait for tons of NF_ACCEPT because
I will be holding those packets in my queue. is that a flawed argument
and can I just reinject the packets into the processing by calling
NF_ACCEPT?

Also if I directly send to the device are there are fields/operations
I need to set before sending the packet out ?

any help will be greatly appreciated

-shrin
