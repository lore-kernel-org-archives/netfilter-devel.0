From: ratheesh k <ratheesh.ksz@gmail.com>
Subject: connection tracking module
Date: Wed, 16 Dec 2009 21:57:32 +0530
Message-ID: <cfeab66d0912160827m729076bbx95189395cd4529a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi ,

      I am a little confused about connection tracking .  I would like
to clarify those with your valuable inputs . If you can find some time
, i will be grateful .


      1. Each connection tacking module ( example  - nf_conntrack_ftp
) will keep its own independent tuple hash tables ??
      2. Suppose i have  nf_conntrack_ftp , nf_conntrack_proto_tcp
modules  loaded . If i initiate a data transfer using ftp protocol ,
which connection tracking module will have tuple information .?
          { My question is :- > if i dont have nf_conntrack_proto_ftp
loaded , it will be tracked by nf_conntrack_proto_tcp }
      3. for the question 2 , which will be skb->nfct contains ?
      4. what exactly helper routines does ? is it only find out
related connection .or any other functionality ?
      5. nf_conntrack_proto_tcp also has helper routines ?

Thanks,
Ratheesh
