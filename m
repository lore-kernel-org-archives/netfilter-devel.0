From: "Ian Brown" <ianbrn@gmail.com>
Subject: netfilter and packets which are created locally
Date: Tue, 27 Jun 2006 07:38:46 +0300
Message-ID: <d0383f90606262138s306427fdpb1fb713ccde61e3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello,
This message was sent 2 days ago to the netdev mailing list but got no
answers. And in a second thought,this list may be a better place for it:

 I had looked at the diagrams and read the explanations
about netfilter in Netfilter Architecture page:
http://netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO-3.html

I want to make sure wheter I undestood something regarding
packets which are created locally (as opposed
to packets that are received on the network interface).

My question is: Do I understand the following 2 sceanrios right?
For local packets which are sent out of the machine
it seems to me to be the case. (Am I right?):
Such packets , that are created locally on
the machine, first reach the NF_IP_LOCAL_OUT [5] hook.
Than they go to the routing stage, and than they go to
NF_IP_POST_ROUTING [4]. And then they go out ?
Such packets, which are created locally,  don't pass at all
at the [1] stage, NF_IP_PRE_ROUTING [1] , and not
in NF_IP_LOCAL_IN [2] stage and not in NF_IP_FORWARD [3] .

Is it true?


Suppose I create locally packets which are destined to
myself (like ping myself). I assume that they will go first to the
NF_IP_LOCAL_OUT [5] , than to the routing stage, but will they go
to the NF_IP_POST_ROUTING [4].?

And again,such packets, which are created locally,  don't pass at all
at the [1] stage, NF_IP_PRE_ROUTING [1] , and not
in NF_IP_LOCAL_IN [2] stage and not in NF_IP_FORWARD [3] .

Is it true?

IB
