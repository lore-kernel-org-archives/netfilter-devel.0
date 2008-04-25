From: "Emmanuel B" <emmanuel.b.lists@gmail.com>
Subject: libnetfilter_conntrack: Unable to create an entry in the expectation table (invalid argument)
Date: Fri, 25 Apr 2008 11:25:39 +0200
Message-ID: <a82687b60804250225p6b0bb892j796b80e14dc0bdcd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

The example program (expect_create) given in the utils directory of
libnetfilter_conntrack return the error code -1 (Invalid argument).
The master entry was correctly added to the conntrack table, but
nothing appears in expect table.

I have tested it on a RedHat 2.6.18 and Ubuntu 2.6.22 with the same result.
I use the libnetfilter_conntrack version 0.0.89 and libnfnetlink version 0.0.33

Is there anything wrong in the expect_create.c code or something
missing in kernel or libnetfilter_conntrack?

Thanks.
