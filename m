From: Nishit Shah <nsshah.82@gmail.com>
Subject: arptables ruleset not working when compiling on fedora6,7,8/centos
	5/redhat 5
Date: Mon, 29 Jun 2009 19:42:11 +0530
Message-ID: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
         I am compiling arptables-v0.0.3-3/arptables-v0.0.3-2 on
fedora6,7,8/centos 5/redhat 5. Module is compiled successfully.
Following are the simple steps.

        make
        make install

        Now, I am applying following rules,

        arptables -N user1
        arptables -N user2
        arptables -N user3

        arptables -A INPUT -j user1
        arptables -A INPUT -j user2
        arptables -A INPUT -j user3

       when I am doing arptables -nvx -L, I am getting packet counts
on only "arptables -A INPUT -j user1", no packet counts on user2 and
user3 chains. If I remove the user1 chain, I am getting packet counts
on user2 chain, not on user3 chain. It means only the first user
defined chain is traversing.

       all above machine contains gcc >= 4.1.2 and glibc >= 2.5

       If i compile the same source with machine having gcc 2.96 and
glibc 2.2.4 things are working properly on the above machines.
       Is it something related to gcc and/or glibc ? as I am not
seeing any issues with kernel space arptables code.

Rgds,
Nishit Shah.
