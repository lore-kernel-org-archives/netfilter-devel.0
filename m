From: Francisco Javier Cabello Torres <fjcabello@visual-tools.com>
Subject: Re: http&rtsp kernel 'proxy'
Date: Thu, 2 Oct 2003 15:31:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310021531.33972.fjcabello@visual-tools.com>
References: <200310021145.10243.fjcabello@visual-tools.com> <1268892368.20031002141507@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DarKRaveR <DarKRaveR@habitat-b.de>
In-Reply-To: <1268892368.20031002141507@habitat-b.de>
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

Hello,
thanks for your reply.
RTSP protocol is similar to HTTP. There are some situations where server may 
start a connections, but not in my environment.
If I have understood it, I have to implement two 'matches', one of then for 
RTSP and the other one for HTTP. With iptables I could add rules to redirect 
rstp and http traffic to different ports. Should I modified iptables 
application, by adding a dynamic library, in order to support new 'matches'?

Regards,

Paco

-- 
Stop software patents!
examples: http://www.base.com/software-patents/examples.html
stop it, see http://petition.eurolinux.org & http://petition.ffii.org/eubsa/en

 15:26:00 up 1 day, 22:53,  1 user,  load average: 0.06, 0.02, 0.00
