From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_helper-any error
Date: Mon, 22 Mar 2004 12:53:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <405ED3AF.8030304@trash.net>
References: <NEBBJFIAIKIHKGJDONCDAEMMCCAA.smith-peter@comcast.net> <20040317135825.GA21899@sunbeam.de.gnumonks.org> <Pine.LNX.4.58L.0403221249000.1288@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>,
  laforge@gnumonks.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
In-Reply-To: <Pine.LNX.4.58L.0403221249000.1288@alpha.zarz.agh.edu.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Wojciech 'Sas' Cieciwa wrote:
> in ipt_helper-any modules is IMHO error
> In line 74 id :
> 	if (info->data[0] == '\0')
> 
> but data isn't declared, here is nedded this "data" not "name" ??

Thanks Wojciech, I'm going to fix this.

Regards
Patrick


> 
> 					Sas.
