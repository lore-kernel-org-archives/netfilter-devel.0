From: Leandro Melo de Sales <leandroal@gmail.com>
Subject: Nat types implemented by IPTABLES - STUN issue
Date: Wed, 5 Jan 2005 16:28:42 -0300
Message-ID: <5bc4c45705010511286ee56a0d@mail.gmail.com>
Reply-To: Leandro Melo de Sales <leandroal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi folks,

 I'm using an implementation for STUN (RFC 3489:
http://www.faqs.org/rfcs/rfc3489.html) written in JAVA
(http://stun4j.dev.java.net/).
 In this RFC, they describes some nats variations (see STUN RFC
chapter 5) some of them supported by STUN specification, like: Full
Cone, Restricted Cone, Port Restricted Cone and Symmetric.
 So, I have a simple question for iptables developers: what types of
nat iptables supports?

Thank you in advanced...

Leandro.
