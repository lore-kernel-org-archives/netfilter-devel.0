From: Ulysses Almeida <munky@maluco.com.br>
Subject: NF_QUEUE examples
Date: Thu, 15 Apr 2004 12:22:20 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040415162220.GA5747@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  I alredy googled for this topic, but couldn't find any nice text
about.

  I want to understand more about NF_QUEUE return, and possibly use
it. So, where can i find simple examples of using it? Or a text
explaining about it.

  What I understand, is: with NF_QUEUE, I can queue some packet to be
manipulated on userspace. After this, can this packet be dequeued back
to kernel space, and continue with it's journey? How can I write a
userspace code, to handle with packetd queued bu NF_QUEUE? Or I didn't
understand nothing about it?

  Thanks for any help in advance!

-- 
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux! 
   ^^-^^
