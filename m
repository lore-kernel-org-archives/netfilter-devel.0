From: chentschel2@arnet.com.ar
Subject: newbie question.
Date: Mon, 25 Aug 2003 09:11:47 -0400 (WST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308251311.h7PDBlp21228@webserver7.arnet.com.ar>
Reply-To: chentschel2@arnet.com.ar
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Please , 
     I\'m trying to write a new module and i need some help ;). 
     What i need to do is a module for dnat UDP packets but always to the same IP if they came from a determinated IP.. i don\'t know if i\'m clear.. but the idea is to use it for UDP RAS msgs in an h323 session... haveing a proxy that balance all those msgs to some RAS servers.
     well i thougth to write an nat-helper module.. but i don;t know if it\'s right.. may be the right thing is to write a new target module?.. 
    Please can someone give me a hand with this? 

Thanks a lot in advance. 
Christian.
