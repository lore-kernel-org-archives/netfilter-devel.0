From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
Subject: TCP connection  and interface down
Date: Tue, 20 Jun 2006 12:20:42 +0530 (IST)
Message-ID: <1535.10.107.26.27.1150786242.squirrel@gpo.iitb.ac.in>
References: <58963.10.107.26.27.1149788221.squirrel@gpo.iitb.ac.in>   
	<4496BADF.5000405@trash.net>
	<4921.10.12.25.5.1150745018.squirrel@gpo.iitb.ac.in>
	<4496FBBB.8090303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4496FBBB.8090303@trash.net>
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

Hi,
  Suppose I have an active tcp connection(web browser) bounded to an
interface X. Whenever this interface goes down, this will be notified by
the kernel stack to the transport layer and the tcp application will
stop sending packets till interface becomes active.

 My questions is that , is it possible to allow tcp applications to keep
on sending packets even after interface goes down. So, that I can catch
packets using IPtables and do whatever manipulation I would like to do.
Also I have another interface to send these manipulated packets.

 Guide me,

 Thanx in advance.
