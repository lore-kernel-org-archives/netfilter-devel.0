From: chentschel@arnet.com.ar
Subject: Search string in skbuff
Date: Tue, 26 Apr 2005 12:33:55 -0300 (ART)
Message-ID: <200504261533.MAA07781@webserver4.arnet.com.ar>
Reply-To: chentschel@arnet.com.ar
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
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

Hi, 
    Is there any plan, or something going to let to find a string or a set of bytes directly in skbuff, without needing to copy it to an array in > 2.6 kernel ? . I\'m asking about this, because of the helper\'s need of use skb_header_pointer() to copy it to a static array. 

Thanks in advance.

Christian Hentschel.
__________________________________
Registrate desde http://servicios.arnet.com.ar/registracion/registracion.asp?origenid=9 y participá de todos los beneficios del Portal Arnet.
