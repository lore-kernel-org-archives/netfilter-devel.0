From: Fabio Spelta <fabio.spelta@tiscali.it>
Subject: Re: Which version of libipq? (or: "How to compile "OSFPE" "?)
Date: 16 Feb 2003 09:41:32 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1045388493.1183.5.camel@vaniglia>
References: <1045307166.1157.37.camel@vaniglia>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1045307166.1157.37.camel@vaniglia>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> gcc -Inetfilter/userspace/include/libipq/ -lnetfilter/userspace/libipq/
> osfpe.c : 
> 
> /usr/bin/ld: cannot find -lnetfilter/userspace/libipq/
> collect2: ld returned 1 exit status

Sorry, I have forgotten to say that I _have_ compiled "libipq" with
"make" before doing that. I also have installed the libreries (
# make install-devel
)
But I cannot find a way to compile the tool, anyway.

Thank you guys

-- 
  Fabio Spelta
  
   email:  spelta@linux.it
   jabber: febs@jabber.linux.it
   ecdl project: http://ecdllibre.sf.net
