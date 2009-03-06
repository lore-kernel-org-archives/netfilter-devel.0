From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] libnetfilter_queue 0.0.17 release
Date: Fri, 06 Mar 2009 18:11:46 +0100
Message-ID: <49B15952.4060909@netfilter.org>
References: <49B1586A.8060308@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060509010409030603060602"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <49B1586A.8060308@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060509010409030603060602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> Hi!
> 
> The netfilter project proudly presents:
> 
>   * libnetfilter_queue-0.0.17
> 
> libnetfilter_queue is a userspace library providing an API to packets
> that have been queued by the kernel packet filter. It is is part of a
> system that deprecates the old ip_queue / libipq mechanism.
> 
> ChangeLog of this release is attached for more details.

Sorry, I forgot to attach the changelog.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060509010409030603060602
Content-Type: text/plain;
 name="ChangeLog-libnetfilter_queue-0.0.17"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog-libnetfilter_queue-0.0.17"

Bart De Schuymer (1):
      nfqnl_test: add hw src address, physindev and physoutdev support

Eric Leblond (6):
      doc: complete missing function documentation
      Change variable name to have an homogeneous naming
      Use nfq_fd function instead of call to nfnetlink function.
      Suppress double call of nfnl_subsys_close()
      Switch documentation style to doxygen.
      Add doxygen config file.

Pablo Neira Ayuso (5):
      conditional compilation of testsuite utils
      doc: add library documentation from Brad Fisher
      doc: put doxygen configuration file into diet
      nfq: replace nfnl_talk by nfnl_query and disable sequence tracking
      build: bump version to 0.0.17


--------------060509010409030603060602--
