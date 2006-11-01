From: "Adayadil Thomas" <adayadil.thomas@gmail.com>
Subject: nf_reinject and NF_STOLEN
Date: Wed, 1 Nov 2006 15:22:08 -0500
Message-ID: <fb7befa20611011222q345dd44bv48833f8a0aecf68b@mail.gmail.com>
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

Greetings.

I read from the netfilter mailing list / howto that nf_reinject is
supposed to be called
after a hook returns NF_QUEUE.

I am trying to return NF_STOLEN on a particular packet(s) and later
send these out.

Scenario I want to create:
---- packet 1 comes in ----> store it temporarily and return NF_STOLEN
---- packet 2 comes in ----> store it temporarily and return NF_STOLEN
---- packet 3 comes in ----> send out packet1 , packet2 and packet3

Any advice or information about how this can be achieved ? Where I
would need to make changes ?

Thanks a lot
Thomas
