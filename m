From: "gan hawk" <ganhawk@gmail.com>
Subject: Re: download stopper
Date: Sun, 14 May 2006 15:31:26 -0500
Message-ID: <3305af120605141331wfd66467l843342f18b36119e@mail.gmail.com>
References: <4465B6C5.1080006@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: varun <varun@rocsys.com>
In-Reply-To: <4465B6C5.1080006@rocsys.com>
Content-Disposition: inline
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

You can use L7 filtering to filter by file types
(http://l7-filter.sourceforge.net/protocols) or limit the size of the
download (using something like
http://www.lowth.com/rope/HttpContentLength) to allow the normal html
files, graphics etc.


On 5/13/06, varun <varun@rocsys.com> wrote:
> Hi,
>
>          Can anyone suggest me a way in which i can stop http downloads
> but not http traffic.
>         Say iam browsing and downloading a file from internet...my
> traffic will go through the gateway. Is there anyway i
>         as a admin stop the download only but not the other http
> traffic.Any suggestions?
>
> Varun
>
>
>
